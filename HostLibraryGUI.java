package eecs285.proj4.naugust;

import java.awt.BorderLayout;

import javax.swing.JButton;
import javax.swing.JFrame;

public class HostLibraryGUI extends LibraryGUI
{
  
  public HostLibraryGUI(JFrame parent)
  {
    super(parent);
    
    JButton endParty = new JButton("End Party");
    add(endParty, BorderLayout.SOUTH);
    
    updateJList(songList);
    
  }
  
  
  
  
  
}