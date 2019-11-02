namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace HH\Lib\{C, Str, Vec};
use namespace Nuxed\EventDispatcher\{Event, EventListener};

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
  public function listen<T as Event\IEvent>(
    classname<T> $event,
    EventListener\IEventListener<T> $listener,
    int $priority = 1,
  ): void {
    $priority = Str\format('%d.0', $priority);
    if (
      C\contains_key($this->listeners, $priority) &&
      C\contains_key($this->listeners[$priority], $event) &&
      C\contains($this->listeners[$priority][$event], $listener)
    ) {
      return;
    }

    $priorityListeners = $this->listeners[$priority] ?? dict[];
    $eventListeners = $priorityListeners[$event] ?? vec[];
    $eventListeners[] = $listener;
    $priorityListeners[$event] = $eventListeners;
    /* HH_FIXME[4110] */
    $this->listeners[$priority] = $priorityListeners;
  }

  /**
   * {@inheritdoc}
   */
  public async function getListeners<<<__Enforceable>> reify T as Event\IEvent>(
    T $event,
  ): AsyncIterator<EventListener\IEventListener<T>> {
    $priorities = Vec\keys($this->listeners)
      |> Vec\sort($$, ($a, $b) ==> $a <=> $b);

    foreach ($priorities as $priority) {
      foreach ($this->listeners[$priority] as $eventName => $listeners) {
        if (\is_a($event, $eventName)) {
          foreach ($listeners as $listener) {
            /* HH_FIXME[4110] */
            yield $listener;
          }
        }
      }
    }
  }
}
