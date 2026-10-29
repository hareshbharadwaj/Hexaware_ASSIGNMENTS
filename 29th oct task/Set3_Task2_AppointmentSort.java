import java.util.Arrays;
import java.util.Comparator;

public class Set3_Task2_AppointmentSort {
    static class Appointment {
        String patient; int urgency, arrival;
        Appointment(String patient,int urgency,int arrival){this.patient=patient;this.urgency=urgency;this.arrival=arrival;}
    }
    public static void main(String[] args) {
        Appointment[] a={new Appointment("P1",2,930),new Appointment("P2",1,945),new Appointment("P3",1,910)};
        Arrays.sort(a, Comparator.comparingInt((Appointment p)->p.urgency).thenComparingInt(p->p.arrival));
        for(Appointment p:a)System.out.println(p.patient+" urgency="+p.urgency+" arrival="+p.arrival);
        System.out.println("Lower urgency number is treated as higher priority.");
    }
}