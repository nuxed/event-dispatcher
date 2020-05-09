namespace Nuxed\EventDispatcher\EventListener;

use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};

/**
 * Helper function to create an event listener,
 * from a callable.
 *
 * @see Nuxed\EventDispatcher\EventListener\CallableEventListener
 */
function callable<T as Event\IEvent>(
  (function(T): Awaitable<void>) $listener,
): EventListener\IEventListener<T> {
  return new CallableEventListener($listener);
}
