namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\EventDispatcher\{Event, EventListener};

/**
 * Mapper from an event to the listeners that are applicable to that event.
 */
interface IListenerProvider {
  /**
   * Retrieve all listeners for the given event.
   *
   * @param T $event
   *   An event for which to return the relevant listeners.
   * @return AsyncIterator<EventListener\IEventListener<T>>
   *   An async iterator (usually an async generator) of listeners. Each
   *   listener MUST be type-compatible with $event.
   */
  public function getListeners<T as Event\IEvent>(
    T $event,
  ): AsyncIterator<EventListener\IEventListener<T>>;
}
