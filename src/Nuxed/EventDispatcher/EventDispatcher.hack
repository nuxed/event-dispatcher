namespace Nuxed\EventDispatcher;

use namespace HH\Lib;
use namespace Nuxed\Contract\EventDispatcher;
use namespace Nuxed\Contract\EventDispatcher\{Event, ListenerProvider};

final class EventDispatcher implements EventDispatcher\IEventDispatcher {
  public function __construct(
    private ListenerProvider\IListenerProvider $listenerProvider,
  ) {}

  /**
   * Provide all relevant listeners with an event to process.
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

        await $listener->process($event);
      };
    }

    await $lastOperation;
    return $event;
  }
}
