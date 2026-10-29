import java.util.HashMap;
import java.util.Map;

public class Set2_Task3_DuplicatePosting {
    static class Transaction {
        String account, merchant; int amount; long seconds;
        Transaction(String account, int amount, String merchant, long seconds) {
            this.account=account; this.amount=amount; this.merchant=merchant; this.seconds=seconds;
        }
    }
    public static void main(String[] args) {
        Transaction[] tx = {
            new Transaction("A10",900,"ShopX",1000),
            new Transaction("A10",900,"ShopX",1040),
            new Transaction("A10",900,"ShopY",1030)
        };
        Map<String, Long> lastSeen = new HashMap<>();
        for (Transaction t : tx) {
            String key=t.account+"|"+t.amount+"|"+t.merchant;
            Long previous=lastSeen.get(key);
            if (previous != null && t.seconds-previous <= 60)
                System.out.println("POSSIBLE DUPLICATE: " + key + " within " + (t.seconds-previous) + " seconds");
            lastSeen.put(key,t.seconds);
        }
    }
}