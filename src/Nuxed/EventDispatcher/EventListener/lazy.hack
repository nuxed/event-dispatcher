namespace Nuxed\EventDispatcher\EventListener;

use namespace His\Container;
use namespace Nuxed\EventDispatcher\Event;

/**
 * Helper function to create a lazy loaded event listener.
 */
function lazy<T as Event\IEvent>(
  Container\ContainerInterface $container,
  classname<IEventListener<T>> $service,
): IEventListener<T> {
  return callable<T>(
    (T $event) ==>
      $container->get<IEventListener<T>>($service)->process($event),
  );
}
