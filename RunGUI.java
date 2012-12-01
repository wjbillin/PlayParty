package eecs285.proj4.naugust;
import javax.swing.JFrame;

public class RunGUI
{
  
  public static void main(String [] args)
  {

    HomeGuiClass home;
    
    home = new HomeGuiClass("Home Inventory Syetem");
    home.pack();
    home.setVisible(true);
    home.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    /*
    Tab tab;
    tab = new Tab("THIS is a tab");
    tab.pack();
    tab.setVisible(true);
    tab.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); */
    
  }
}