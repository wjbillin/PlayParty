package eecs285.proj4.naugust;

import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JTabbedPane;



public class Tab extends JFrame
{
  
  
  Tab(String inTitle)
  {
    super(inTitle);
    
    JTabbedPane jtp = new JTabbedPane();
    getContentPane().add(jtp);
 
    
    LibraryGUI two = new LibraryGUI();
    QueueGUI one = new QueueGUI();
    
    
   /* JLabel label1 = new JLabel();
    label1.setText("Introduction");
    JLabel label2 = new JLabel();
    label2.setText("History");*/
    //one.add(label1);
    //two.add(label2);
    jtp.addTab("Tab1", one);
    jtp.addTab("Tab2", two);
    pack();
    setVisible(true);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }
  
  @Override
  public Dimension getPreferredSize() {
      return new Dimension(400, 500);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}