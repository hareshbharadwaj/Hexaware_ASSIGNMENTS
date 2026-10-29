public class Set3_Task4_HospitalDesk {
    static class Stack {
        String[] data=new String[10]; int top=-1;
        void push(String s){if(top==data.length-1)throw new IllegalStateException("full");data[++top]=s;}
        String pop(){if(top<0)throw new IllegalStateException("empty");return data[top--];}
    }
    static class Queue {
        String[] data=new String[10]; int head=0,tail=0;
        void add(String s){if(tail==data.length)throw new IllegalStateException("full");data[tail++]=s;}
        String remove(){if(head==tail)throw new IllegalStateException("empty");return data[head++];}
    }
    public static void main(String[] args) {
        Queue q=new Queue();q.add("P201");q.add("P202");System.out.println("Next walk-in token: "+q.remove());
        Stack history=new Stack();history.push("P100");history.push("P105");System.out.println("Most recently viewed: "+history.pop());
    }
}