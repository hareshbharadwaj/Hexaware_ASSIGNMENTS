public class Set2_Task2_TransactionSort {
    static class Transaction {
        String id; int time, amount;
        Transaction(String id, int time, int amount) { this.id=id; this.time=time; this.amount=amount; }
    }
    static void insertionSort(Transaction[] a) {
        for (int i=1; i<a.length; i++) {
            Transaction key=a[i]; int j=i-1;
            while (j>=0 && a[j].time > key.time) { a[j+1]=a[j]; j--; }
            a[j+1]=key;
        }
    }
    public static void main(String[] args) {
        Transaction[] tx = {new Transaction("T1",930,100), new Transaction("T2",915,250), new Transaction("T3",930,75)};
        insertionSort(tx);
        for (Transaction t : tx) System.out.println(t.id + " " + t.time + " amount=" + t.amount);
        System.out.println("Stable: T1 remains before T3 at the same timestamp.");
    }
}