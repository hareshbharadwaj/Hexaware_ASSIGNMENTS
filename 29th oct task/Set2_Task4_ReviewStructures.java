public class Set2_Task4_ReviewStructures {
    static class IntStack {
        int[] data=new int[20]; int top=-1;
        void push(int x){if(top==data.length-1)throw new IllegalStateException("full");data[++top]=x;}
        int pop(){if(top<0)throw new IllegalStateException("empty");return data[top--];}
    }
    static class IntQueue {
        int[] data=new int[20]; int head=0,tail=0;
        void add(int x){if(tail==data.length)throw new IllegalStateException("full");data[tail++]=x;}
        int remove(){if(head==tail)throw new IllegalStateException("empty");return data[head++];}
    }
    public static void main(String[] args) {
        IntQueue review=new IntQueue(); review.add(7001); review.add(7002);
        System.out.println("Review first: " + review.remove());
        IntStack adjustments=new IntStack(); adjustments.push(51); adjustments.push(52);
        System.out.println("Reverse last adjustment: " + adjustments.pop());
    }
}