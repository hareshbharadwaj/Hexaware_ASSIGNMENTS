import java.util.Arrays;

public class Set1_Task2_OrderSort {
    static void bubbleDescending(int[] a) {
        for (int i = 0; i < a.length - 1; i++)
            for (int j = 0; j < a.length - 1 - i; j++)
                if (a[j] < a[j + 1]) {
                    int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t;
                }
    }
    static void mergeSortDescending(int[] a, int left, int right) {
        if (left >= right) return;
        int mid = left + (right - left) / 2;
        mergeSortDescending(a, left, mid);
        mergeSortDescending(a, mid + 1, right);
        int[] temp = new int[right - left + 1];
        int i = left, j = mid + 1, k = 0;
        while (i <= mid && j <= right) temp[k++] = a[i] >= a[j] ? a[i++] : a[j++];
        while (i <= mid) temp[k++] = a[i++];
        while (j <= right) temp[k++] = a[j++];
        System.arraycopy(temp, 0, a, left, temp.length);
    }
    public static void main(String[] args) {
        int[] sample = {450, 1200, 99, 700, 320};
        int[] bubble = sample.clone(), merge = sample.clone(), builtIn = sample.clone();
        bubbleDescending(bubble);
        mergeSortDescending(merge, 0, merge.length - 1);
        Arrays.sort(builtIn);
        for (int i = 0; i < builtIn.length / 2; i++) {
            int t = builtIn[i]; builtIn[i] = builtIn[builtIn.length - 1 - i];
            builtIn[builtIn.length - 1 - i] = t;
        }
        System.out.println("Bubble sort: " + Arrays.toString(bubble));
        System.out.println("Merge sort:  " + Arrays.toString(merge));
        System.out.println("Built-in:    " + Arrays.toString(builtIn));
    }
}