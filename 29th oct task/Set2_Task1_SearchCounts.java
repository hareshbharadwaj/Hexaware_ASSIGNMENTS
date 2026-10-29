public class Set2_Task1_SearchCounts {
    static int binarySearch(int[] ids, int key) {
        int left = 0, right = ids.length - 1, comparisons = 0;
        while (left <= right) {
            comparisons++;
            int mid = left + (right - left) / 2;
            if (ids[mid] == key) { System.out.println("Found after " + comparisons + " comparisons"); return mid; }
            if (ids[mid] < key) left = mid + 1; else right = mid - 1;
        }
        System.out.println("Not found after " + comparisons + " comparisons");
        return -1;
    }
    public static void main(String[] args) {
        int[] ids = new int[100_000];
        for (int i = 0; i < ids.length; i++) ids[i] = i + 1;
        binarySearch(ids, 50_001);
        binarySearch(ids, 1);
        binarySearch(ids, 100_001);
        System.out.println("Linear search best/average/worst: 1 / about 50000 / 100000");
        System.out.println("Binary search worst case: about 17 comparisons");
    }
}