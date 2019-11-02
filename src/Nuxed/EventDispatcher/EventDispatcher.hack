namespace Nuxed\EventDispatcher;

use namespace HH\Lib;
use namespace Nuxed\EventDispatcher\{Event, EventListener};

final class EventDispatcher implements IEventDispatcher {
  public function __construct(
    private ListenerProvider\IListenerProvider $listenerProvider,
  ) {}

  /**
   * Provide all relevant listeners with an event to process.
   *
   * If a Throwable is caught when executing the listener loop, it is cast
   * to an ErrorEvent, and then the method calls itself with that instance,
   * re-throwing the original Throwable on completion.
   *
   * In the case that a Throwable is caught for an ErrorEvent, we re-throw
   * to prevent recursion.
   *
   * @template T as IEvent
   *
   * @return T The Event that was passed, now modified by listeners.
   */
  public async function dispatch<<<__Enforceable>> reify T as Event\IEvent>(
    T $event,
  ): Awaitable<T> {
    if ($event is Event\IStoppableEvent && $event->isPropagationStopped()) {
      return $event;
    }

    $listeners = $this->listenerProvider->getListeners<T>($event);
    $stopped = new Lib\Ref(false);
    $lastOperation = async {
    };

    foreach ($listeners await as $listener) {
      if ($stopped->value) {
        break;
      }

      $lastOperation = async {
        await $lastOperation;
        if ($event is Event\IStoppableEvent && $event->isPropagationStopped()) {
          $stopped->value = true;
          return;
        }

        try {
          await $listener->process($event);
        } catch (\Exception $e) {
          if ($event is Event\ErrorEvent<_>) {
            throw new Exception\InvalidListenerException('');
            throw $event->getException();
          }

          await $this->handleCaughtException<T>($e, $event, $listener);
        }
      };
    }

    await $lastOperation;
    return $event;
  }

  private async function handleCaughtException<
    <<__Enforceable>> reify T as Event\IEvent,
  >(
    \Exception $e,
    T $event,
    EventListener\IEventListener<T> $listener,
  ): Awaitable<noreturn> {
    await $this->dispatch<Event\ErrorEvent<T>>(
      new Event\ErrorEvent<T>($event, $listener, $e),
    );

    // Re-throw the original exception, per the spec.
    throw $e;
  }
}
