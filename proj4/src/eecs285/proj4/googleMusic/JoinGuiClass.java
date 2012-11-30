package eecs285.proj4.googleMusic;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.ArrayList;
import java.util.Collections;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.ListSelectionModel;

import eecs285.proj4.googleMusic.LoginGuiClass.LoginListener;

public class JoinGuiClass extends JDialog implements WindowListener  {
  
  private JButton join;
  private JButton refresh;
  private JButton cancel;
  protected JList listedItems;
  protected DefaultListModel partyList;
  protected ArrayList<sessionData> behindDisplay = new ArrayList<sessionData>();
  private JPanel buttonPanel;
  private JPanel largerPanel;
  private ActionListener joinButtonListener;
  private ActionListener cancelButtonListener;
  private ActionListener refreshButtonListener;
  private boolean refreshBeenPushed = false;
    

  
  public JoinGuiClass(JFrame homeFrame, String title) {
    
    super(homeFrame, title, true);
    setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    setResizable(false);
    setLocationRelativeTo(homeFrame);
    addWindowListener(this);
    setLayout(new BorderLayout());

    partyList = new DefaultListModel();
    listedItems = new JList(partyList);
    listedItems.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    listedItems.setLayoutOrientation(JList.VERTICAL);
    add(listedItems, BorderLayout.CENTER);
    partyList.addElement("Click the refresh button");

    largerPanel = new JPanel(new GridLayout(2,1));
    refresh = new JButton("Refresh list");
    refreshButtonListener = new ButtonListener();
    refresh.addActionListener(refreshButtonListener);
    largerPanel.add(refresh);
    
    buttonPanel = new JPanel(new GridLayout(1,2));
    join = new JButton("Join Session");
    joinButtonListener = new ButtonListener();
    join.addActionListener(joinButtonListener);
    buttonPanel.add(join);
    cancel = new JButton("Cancel");
    cancelButtonListener = new ButtonListener();
    cancel.addActionListener(cancelButtonListener);
    buttonPanel.add(cancel);
    largerPanel.add(buttonPanel);
    add(largerPanel, BorderLayout.SOUTH);
    pack();    
    
    
  }
  public class ButtonListener implements ActionListener {
    public void actionPerformed(ActionEvent e) {
      
      if (e.getSource().equals(join)) {
        if (refreshBeenPushed) {
          sessionData selectedInList = behindDisplay.get(listedItems.getSelectedIndex());
          System.out.println("Joining: " + selectedInList.getName());
          setVisible(false); 
          new ControlPannelGuiClass(JoinGuiClass.this, selectedInList.getName() + "'s party", true, selectedInList).setVisible(true);

          //goto ControlPannelGuiClass jdialog
        }
      }
      else if (e.getSource().equals(cancel)) {
        setVisible(false);
        dispose();
      }
      else if (e.getSource().equals(refresh)) {
        ArrayList<sessionData> fromServer = new ArrayList<sessionData>(); 
        refreshBeenPushed = true;
        partyList.clear();
        behindDisplay.clear();
        
        //call the server and find all of the available sessions
        sessionData newData = new sessionData("Brian's Party");
        fromServer.add(newData);
        newData = new sessionData("Avi's Party");
        fromServer.add(newData);
        newData = new sessionData("Nick's Party");
        fromServer.add(newData);
        newData = new sessionData("Savannah's Party");
        fromServer.add(newData);
        newData = new sessionData("Josh's Party");
        fromServer.add(newData);
        behindDisplay = fromServer;
        
        int x = 0;
        while (x < behindDisplay.size()) {
          partyList.addElement(behindDisplay.get(x).getName());
          x++;          
        }
        pack();  
      }
    }     
  }
  

 

  @Override
  public void windowClosed(WindowEvent e) {
    JFrame parentFrame = (JFrame) getParent();
    parentFrame.setVisible(true);    
  }



  @Override
  public void windowClosing(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }



  @Override
  public void windowDeactivated(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }



  @Override
  public void windowDeiconified(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }



  @Override
  public void windowIconified(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }



  @Override
  public void windowOpened(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void windowActivated(WindowEvent e) {
    // TODO Auto-generated method stub
    
  }


}
