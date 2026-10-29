import java.util.HashSet;
import java.util.Set;

public class Set3_Task3_DoubleBooking {
    static class Booking {
        String patient, slot;
        Booking(String patient,String slot){this.patient=patient;this.slot=slot;}
    }
    public static void main(String[] args) {
        Booking[] bookings={new Booking("P100","10:00"),new Booking("P200","10:00"),new Booking("P100","10:00")};
        Set<String> seen=new HashSet<>();
        for(Booking b:bookings){String key=b.patient+"|"+b.slot;if(!seen.add(key))System.out.println("DOUBLE BOOKING: "+key);}
    }
}