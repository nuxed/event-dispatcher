namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace HH\Lib\{C, Vec};
use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};

/**
 * The `RandomizedListenerProvider` is a built-in implementation for `IRandomizedListenerProvider`
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IRandomizedListenerProvider
 */
final class RandomizedListenerProvider implements IRandomizedListenerProvider {
  private dict<
    classname<Event\IEvent>,
    vec<EventListener\IEventListener<Event\IEvent>>,
  > $listeners = dict[];

  /**
   * {@inheritdoc}
   */
  public function listen<T as Event\IEvent>(
    classname<T> $event,
    EventListener\IEventListener<T> $listener,
  ): void {
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
    $listeners = vec[];
    foreach ($this->listeners as $type => $eventListeners) {
      if (\is_a($event, $type)) {
        $listeners = Vec\concat($listeners, $eventListeners);
      }
    }

    foreach (Vec\shuffle($listeners) as $listener) {
      /* HH_FIXME[4110] */
      yield $listener;
    }
  }
}
