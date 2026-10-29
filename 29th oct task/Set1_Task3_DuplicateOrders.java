import java.util.HashSet;
import java.util.Set;

public class Set1_Task3_DuplicateOrders {
    static class Order {
        String customerId, minute;
        int amount;
        Order(String customerId, int amount, String minute) {
            this.customerId = customerId; this.amount = amount; this.minute = minute;
        }
    }
    public static void main(String[] args) {
        Order[] orders = {
            new Order("C101", 500, "10:31"),
            new Order("C205", 250, "10:32"),
            new Order("C101", 500, "10:31"),
            new Order("C101", 500, "10:32")
        };
        Set<String> seen = new HashSet<>();
        for (Order o : orders) {
            String key = o.customerId + "|" + o.amount + "|" + o.minute;
            if (!seen.add(key)) System.out.println("DUPLICATE: " + key);
        }
    }
}