package eecs285.proj4.naugust;

import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JTabbedPane;



public class Tab extends JFrame
{
  
  
  Tab(String inTitle, boolean client)
  {
    super(inTitle);
    
    JTabbedPane jtp = new JTabbedPane();
    getContentPane().add(jtp);
    
    
    LibraryGUI clientLibrary = new LibraryGUI(this);
    QueueGUI clientQueue = new QueueGUI();
    HostQueueGUI hostQueue = new HostQueueGUI();
    HostLibraryGUI hostLibrary = new HostLibraryGUI(this);
    

    if(client)
    {
      jtp.addTab("Host Library", clientLibrary);
      jtp.addTab("Queue", clientQueue);
    }
    else
    {
      jtp.addTab("Host Library", hostLibrary);
      jtp.addTab("Queue", hostQueue);
    }
    pack();
    setVisible(true);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }
  
  @Override
  public Dimension getPreferredSize() {
      return new Dimension(500, 500);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}