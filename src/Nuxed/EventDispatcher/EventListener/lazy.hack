namespace Nuxed\EventDispatcher\EventListener;

use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};
use namespace Nuxed\Contract\Container;

/**
 * Helper function to create a lazy loaded event listener.
 */
function lazy<T as Event\IEvent>(
  Container\IContainer $container,
  classname<EventListener\IEventListener<T>> $service,
): EventListener\IEventListener<T> {
  return callable<T>(
    (T $event) ==> $container->get<EventListener\IEventListener<T>>($service)
      ->process($event),
  );
}
