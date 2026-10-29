import java.util.Arrays;

public class Set1_Task1_OrderSearch {
    static int linearSearch(int[] ids, int key) {
        for (int i = 0; i < ids.length; i++) if (ids[i] == key) return i;
        return -1;
    }
    static int binarySearch(int[] ids, int key) {
        int left = 0, right = ids.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (ids[mid] == key) return mid;
            if (ids[mid] < key) left = mid + 1; else right = mid - 1;
        }
        return -1;
    }
    public static void main(String[] args) {
        int[] ids = new int[50_000];
        for (int i = 0; i < ids.length; i++) ids[i] = 100001 + i;
        int key = 125000;
        long start = System.nanoTime();
        int linear = linearSearch(ids, key);
        long linearNs = System.nanoTime() - start;
        start = System.nanoTime();
        int binary = binarySearch(ids, key);
        long binaryNs = System.nanoTime() - start;
        System.out.println("Orders loaded: " + ids.length);
        System.out.println("Linear result index: " + linear);
        System.out.println("Binary result index: " + binary);
        System.out.println("Linear search ns (machine-dependent): " + linearNs);
        System.out.println("Binary search ns (machine-dependent): " + binaryNs);
    }
}