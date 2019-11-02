namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\EventDispatcher\{Event, EventListener};

/**
 * The `IReifiedListenerProvider` uses reified generics features to determine the event type,
 * instead of recieving it as an argument.
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IReifiedListenerProvider extends IListenerProvider {
  /**
   * Attach a listener
   */
  public function listen<<<__Enforceable>> reify T as Event\IEvent>(
    EventListener\IEventListener<T> $listener,
  ): void;
}
