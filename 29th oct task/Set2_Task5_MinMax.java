public class Set2_Task5_MinMax {
    static int[] minMax(int[] a, int left, int right) {
        if (left == right) return new int[]{a[left], a[left]};
        if (right == left + 1) return new int[]{Math.min(a[left],a[right]), Math.max(a[left],a[right])};
        int mid=left+(right-left)/2;
        int[] x=minMax(a,left,mid), y=minMax(a,mid+1,right);
        return new int[]{Math.min(x[0],y[0]), Math.max(x[1],y[1])};
    }
    public static void main(String[] args) {
        int[] amounts={120,45,980,20,500,760,35};
        int[] result=minMax(amounts,0,amounts.length-1);
        System.out.println("Minimum transaction: " + result[0]);
        System.out.println("Maximum transaction: " + result[1]);
        System.out.println("Time: O(n); recursive stack: O(log n)");
    }
}