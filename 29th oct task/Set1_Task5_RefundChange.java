import java.util.Arrays;

public class Set1_Task5_RefundChange {
    static int greedy(int amount, int[] coins) {
        int count = 0;
        for (int coin : coins) { count += amount / coin; amount %= coin; }
        return amount == 0 ? count : -1;
    }
    static int dynamicProgramming(int amount, int[] coins) {
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, amount + 1); dp[0] = 0;
        for (int value = 1; value <= amount; value++)
            for (int coin : coins)
                if (coin <= value) dp[value] = Math.min(dp[value], dp[value - coin] + 1);
        return dp[amount] > amount ? -1 : dp[amount];
    }
    public static void main(String[] args) {
        int[] coins = {4, 3, 1};
        System.out.println("Greedy count for 6: " + greedy(6, coins));
        System.out.println("DP minimum for 6: " + dynamicProgramming(6, coins));
    }
}