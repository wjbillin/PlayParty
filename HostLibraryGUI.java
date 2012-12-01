package eecs285.proj4.naugust;

import java.awt.BorderLayout;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class HostLibraryGUI extends LibraryGUI
{
  
  public HostLibraryGUI(JFrame parent)
  {
    super(parent);
    
    this.endPartyButton.setEnabled(true);
    this.endPartyButton.setVisible(true);
    
    updateButton();
    
    //updateJList(songList);
    
  }
  
  
  
  
  
}