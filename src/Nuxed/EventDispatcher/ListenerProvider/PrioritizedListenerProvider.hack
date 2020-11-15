namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace HH\Lib\{C, Str, Vec};
use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};

/**
 * The `PrioritizedListenerProvider` is a built-in implementation for `IPrioritizedListenerProvider`
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IPrioritizedListenerProvider
 */
final class PrioritizedListenerProvider
  implements IPrioritizedListenerProvider {
  private dict<string, dict<
    classname<Event\IEvent>,
    vec<EventListener\IEventListener<Event\IEvent>>,
  >> $listeners = dict[];

  /**
   * {@inheritdoc}
   */
  public function listen<<<__Enforceable>> reify T as Event\IEvent>(
    EventListener\IEventListener<T> $listener,
    int $priority = 1,
  ): void {
    $event_type = T::class;
    $priority = Str\format('%d.0', $priority);
    if (
      C\contains_key($this->listeners, $priority) &&
      C\contains_key($this->listeners[$priority], $event_type) &&
      C\contains($this->listeners[$priority][$event_type], $listener)
    ) {
      return;
    }

    $priority_listeners = $this->listeners[$priority] ?? dict[];
    $event_listeners = $priority_listeners[$event_type] ?? vec[];
    $event_listeners[] = $listener;
    $priority_listeners[$event_type] = $event_listeners;
    /* HH_FIXME[4110] */
    $this->listeners[$priority] = $priority_listeners;
  }

  /**
   * {@inheritdoc}
   */
  public async function getListeners<<<__Enforceable>> reify T as Event\IEvent>(
  ): AsyncIterator<EventListener\IEventListener<T>> {
    $priorities = Vec\keys($this->listeners)
      |> Vec\sort($$, ($a, $b) ==> $a <=> $b);

    foreach ($priorities as $priority) {
      foreach ($this->listeners[$priority] as $type => $listeners) {
        if (T::class === $type || \is_subclass_of(T::class, $type)) {
          foreach ($listeners as $listener) {
            /* HH_FIXME[4110] */
            yield $listener;
          }
        }
      }
    }
  }
}
