package eecs285.proj4.naugust;

import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

import javax.swing.JDialog;
import javax.swing.JFrame;

public class ControlPannelGuiClass extends JDialog implements WindowListener {

  
  public ControlPannelGuiClass(JDialog lastFrame, String title, boolean host, sessionData currentParty) {
    
    super(lastFrame, title, true);
    setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    setResizable(false);
    setLocationRelativeTo(lastFrame);
    addWindowListener(this);

  }

  @Override
  public void windowActivated(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void windowClosed(WindowEvent arg0) {
    
    JDialog parentFrame = (JDialog) getParent();
    parentFrame.setVisible(true);    
  }

  @Override
  public void windowClosing(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void windowDeactivated(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void windowDeiconified(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void windowIconified(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void windowOpened(WindowEvent arg0) {
    // TODO Auto-generated method stub
    
  }
  

}
