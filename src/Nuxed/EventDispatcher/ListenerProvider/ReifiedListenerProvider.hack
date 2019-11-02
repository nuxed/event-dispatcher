namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace HH\Lib\C;
use namespace HH\ReifiedGenerics;
use namespace Nuxed\EventDispatcher\{Event, EventListener};

/**
 * The `ReifiedListenerProvider` is a built-in implementation for `IReifiedListenerProvider`
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IReifiedListenerProvider
 */
final class ReifiedListenerProvider implements IReifiedListenerProvider {
  private dict<
    classname<Event\IEvent>,
    vec<EventListener\IEventListener<Event\IEvent>>,
  > $listeners = dict[];

  /**
   * {@inheritdoc}
   */
  public function listen<<<__Enforceable>> reify T as Event\IEvent>(
    EventListener\IEventListener<T> $listener,
  ): void {
    $event = ReifiedGenerics\get_classname<T>();

    $listeners = $this->listeners[$event] ?? vec[];
    if (C\contains($listeners, $listener)) {
      // duplicate detected
      return;
    }

    $listeners[] = $listener;
    /* HH_FIXME[4110] */
    $this->listeners[$event] = $listeners;
  }

  /**
   * {@inheritdoc}
   */
  public async function getListeners<<<__Enforceable>> reify T as Event\IEvent>(
    T $event,
  ): AsyncIterator<EventListener\IEventListener<T>> {
    foreach ($this->listeners as $type => $listeners) {
      if (\is_a($event, $type)) {
        foreach ($listeners as $listener) {
          /* HH_FIXME[4110] */
          yield $listener;
        }
      }
    }
  }
}
