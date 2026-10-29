public class Set3_Task1_PatientSearch {
    static int linearSearch(int[] ids,int key){for(int i=0;i<ids.length;i++)if(ids[i]==key)return i;return -1;}
    static int binarySearch(int[] ids,int key){int l=0,r=ids.length-1;while(l<=r){int m=l+(r-l)/2;if(ids[m]==key)return m;if(ids[m]<key)l=m+1;else r=m-1;}return -1;}
    public static void main(String[] args) {
        int[] ids=new int[20_000]; for(int i=0;i<ids.length;i++)ids[i]=200001+i;
        int key=210000; long start=System.nanoTime();
        for(int i=0;i<1000;i++)linearSearch(ids,key);
        long linearNs=System.nanoTime()-start; start=System.nanoTime();
        for(int i=0;i<1000;i++)binarySearch(ids,key);
        long binaryNs=System.nanoTime()-start;
        System.out.println("Records: 20000; lookups: 1000");
        System.out.println("Linear total ns (machine-dependent): "+linearNs);
        System.out.println("Binary total ns (machine-dependent): "+binaryNs);
    }
}