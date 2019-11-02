namespace Nuxed\EventDispatcher\EventListener;

use namespace Nuxed\EventDispatcher\Event;

/**
 * Helper function to create an event listener,
 * from a callable.
 *
 * @see Nuxed\EventDispatcher\EventListener\CallableEventListener
 */
function callable<T as Event\IEvent>(
  (function(T): Awaitable<void>) $listener,
): IEventListener<T> {
  return new CallableEventListener($listener);
}
