import java.util.Arrays;

public class Set3_Task5_AppointmentDP {
    static class Appointment {int start,end;Appointment(int start,int end){this.start=start;this.end=end;}}
    public static void main(String[] args) {
        Appointment[] jobs={new Appointment(9,10),new Appointment(9,12),new Appointment(10,11),new Appointment(11,12)};
        Arrays.sort(jobs,(a,b)->Integer.compare(a.end,b.end));
        int n=jobs.length;int[] dp=new int[n+1];
        for(int i=1;i<=n;i++){
            int previous=i-2;
            while(previous>=0&&jobs[previous].end>jobs[i-1].start)previous--;
            dp[i]=Math.max(dp[i-1],1+dp[previous+1]);
        }
        System.out.println("DP table: "+Arrays.toString(dp));
        System.out.println("Maximum compatible appointments: "+dp[n]);
        System.out.println("For unweighted intervals, earliest-finish-time greedy is optimal.");
    }
}