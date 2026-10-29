public class Set1_Task4_StackQueue {
    static class IntStack {
        private final int[] data = new int[100];
        private int top = -1;
        void push(int value) { if (top + 1 == data.length) throw new IllegalStateException("Stack full"); data[++top] = value; }
        int pop() { if (top < 0) throw new IllegalStateException("Stack empty"); return data[top--]; }
    }
    static class IntQueue {
        private final int[] data = new int[100];
        private int head, tail;
        void add(int value) { if (tail == data.length) throw new IllegalStateException("Queue full"); data[tail++] = value; }
        int remove() { if (head == tail) throw new IllegalStateException("Queue empty"); return data[head++]; }
    }
    public static void main(String[] args) {
        IntStack undo = new IntStack(); undo.push(101); undo.push(102);
        System.out.println("Undo last edit: " + undo.pop());
        IntQueue dispatch = new IntQueue(); dispatch.add(201); dispatch.add(202);
        System.out.println("Next dispatch order: " + dispatch.remove());
    }
}