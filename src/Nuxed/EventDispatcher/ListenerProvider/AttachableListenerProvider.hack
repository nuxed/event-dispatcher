namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace HH\Lib\C;
use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};

/**
 * The `AttachableListenerProvider` is a built-in implementation for `IAttachableListenerProvider`
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IAttachableListenerProvider
 */
final class AttachableListenerProvider implements IAttachableListenerProvider {
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
