# Set 1 — Online Grocery Delivery Application
**Day 3 | 1 November 2026**

## Product vision
Enable customers to browse groceries, build a cart, place orders and track delivery from one application.

## Scrum roles
- Product Owner: maximises value and orders the Product Backlog.
- Scrum Master: facilitates Scrum and removes impediments.
- Developers: build, test and deliver a usable Increment.

## Epics and user stories
**Browse & Search**
1. As a customer, I want to browse categories so I can discover products.
2. As a customer, I want to search by name so I can find products quickly.
3. As a customer, I want to filter by category and price.
4. As a customer, I want to see price and availability.

**Cart & Checkout**
5. As a customer, I want to add products to my cart.
6. As a customer, I want to change item quantities.
7. As a customer, I want to see the order total.
8. As a customer, I want to confirm my address and place an order.

**Delivery Tracking**
9. As a customer, I want to view order status.
10. As a customer, I want to see an estimated delivery window.
11. As a delivery partner, I want to view assigned deliveries.
12. As a customer, I want to receive delivery updates.

## INVEST review
Stories should be Independent, Negotiable, Valuable, Estimable, Small and Testable. Split broad checkout work into address confirmation, order summary, payment selection and order confirmation.

## Acceptance criteria — checkout
- Given available items and a valid address, when checkout is confirmed, then an order number is created and shown.
- Given an unavailable item, when checkout is attempted, then the item is flagged and the cart can be changed.
- Given no delivery address, when checkout is attempted, then the customer is prompted to enter one.

## MoSCoW and estimation
Must: browse, search, cart, total, address and order placement. Should: tracking and updates. Could: delivery-partner view and advanced filters. Example Fibonacci estimates: 3,5,5,2,3,8,5,5,5,3,2,3 = 49 points. Story points are relative estimates, not hours.

## JIRA and team agreements
Create a Scrum project, add epics/stories, estimate points and configure To Do → In Progress → In Review → Done. Suggested Sprint Goal: deliver a complete browse-to-order flow. DoR: value, acceptance criteria, dependencies and size are clear. DoD: reviewed, tested, integrated, acceptance criteria passed and no critical defects.
