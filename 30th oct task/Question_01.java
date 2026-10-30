public class Question_01 {
static class Node{String key;Node left,right;Node(String s){key=s;}}
static Node insert(Node n,String s){if(n==null)return new Node(s);int c=s.compareTo(n.key);if(c<0)n.left=insert(n.left,s);else if(c>0)n.right=insert(n.right,s);return n;}
static boolean search(Node n,String s){if(n==null)return false;if(n.key.equals(s))return true;return s.compareTo(n.key)<0?search(n.left,s):search(n.right,s);}
static void in(Node n){if(n!=null){in(n.left);System.out.print(n.key+" ");in(n.right);}}
static void pre(Node n){if(n!=null){System.out.print(n.key+" ");pre(n.left);pre(n.right);}}
static void post(Node n){if(n!=null){post(n.left);post(n.right);System.out.print(n.key+" ");}}
public static void main(String[]x){String[]a={"Electronics","Books","Clothing","Laptops","Mobiles","Fiction","Nonfiction","Men","Women","Shoes","Home","Kitchen","Furniture","Sports","Toys"};Node r=null;for(String s:a)r=insert(r,s);System.out.print("Inorder: ");in(r);System.out.print("\nPreorder: ");pre(r);System.out.print("\nPostorder: ");post(r);System.out.println("\nSearch Mobiles: "+search(r,"Mobiles"));}}