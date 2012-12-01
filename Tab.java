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
    
    
    LibraryGUI clientLibrary = new LibraryGUI(this);
    QueueGUI clientQueue = new QueueGUI();
    HostQueueGUI hostQueue = new HostQueueGUI();
    HostLibraryGUI hostLibrary = new HostLibraryGUI(this);
    
   /* JLabel label1 = new JLabel();
    label1.setText("Introduction");
    JLabel label2 = new JLabel();
    label2.setText("History");*/
    //one.add(label1);
    //two.add(label2);
    jtp.addTab("Host Library", hostLibrary);
    jtp.addTab("Queue", hostQueue);
    pack();
    setVisible(true);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }
  
  @Override
  public Dimension getPreferredSize() {
      return new Dimension(500, 500);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}