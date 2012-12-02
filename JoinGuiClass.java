package eecs285.proj4.naugust;

import java.awt.BorderLayout;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.ListSelectionModel;

public class JoinGuiClass extends JDialog {//implements WindowListener  {
  
  private JButton join;
  private JButton refresh;
  private JButton cancel;
  protected JList listedItems;
  protected DefaultListModel partyList;
  protected ArrayList<sessionData> behindDisplay = new ArrayList<sessionData>();
 // private JPanel buttonPanel;
 // private JPanel largerPanel;
  private Panel buttonPanel;
  private Panel largerPanel;
  private ActionListener joinButtonListener;
  private ActionListener cancelButtonListener;
  private ActionListener refreshButtonListener;
  private boolean refreshBeenPushed = false;
  private JFrame parent;
    

<<<<<<< HEAD
=======
  
>>>>>>> d17da96bb964643cf8480de34dde927e4c32b531
  public JoinGuiClass(JFrame homeFrame, String title) {
    
    super(homeFrame, title, true);
    setDefaultCloseOperation(HIDE_ON_CLOSE);
    setResizable(false);
    setLocationRelativeTo(homeFrame);
    //addWindowListener(this);
    setLayout(new BorderLayout());
    
    parent = new JFrame();
    parent = homeFrame;
    
    //*****NICK's ****/
    
    partyList = new DefaultListModel();
    listedItems = new JList(partyList);
    listedItems.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    listedItems.setLayoutOrientation(JList.VERTICAL);
    

    largerPanel = new Panel();
    refresh = new JButton("Refresh list");
    refreshButtonListener = new ButtonListener();
    refresh.addActionListener(refreshButtonListener);
    largerPanel.add(refresh);
    
    add(largerPanel, "North");
    
    add(listedItems, BorderLayout.CENTER);
    partyList.addElement("Click the refresh button");
    
    buttonPanel = new Panel();
    join = new JButton("Join Session");
    joinButtonListener = new ButtonListener();
    join.addActionListener(joinButtonListener);
    buttonPanel.add(join);
    cancel = new JButton("Cancel");
    cancelButtonListener = new ButtonListener();
    cancel.addActionListener(cancelButtonListener);
    buttonPanel.add(cancel);
    
    add(buttonPanel, "South");
    //largerPanel.add(buttonPanel);
    //add(largerPanel, BorderLayout.SOUTH);
    pack();    
    
    
    
    //****************/
    
  }
  
  
  public class ButtonListener implements ActionListener {
    public void actionPerformed(ActionEvent e) {
      
      if (e.getSource().equals(join)) {
        if (refreshBeenPushed) {
          sessionData selectedInList = behindDisplay.get(listedItems.getSelectedIndex());
          System.out.println("Joining: " + selectedInList.getName());
<<<<<<< HEAD
          setVisible(false);
=======
          setVisible(false); 
          //new ControlPannelGuiClass(JoinGuiClass.this, selectedInList.getName() + "'s party", true, selectedInList).setVisible(true);
>>>>>>> d17da96bb964643cf8480de34dde927e4c32b531
          new Tab(selectedInList.getName(), true);
          parent.dispose();
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
  

 
/*
  @Override
  public void windowClosed(WindowEvent e) {
    JFrame parentFrame = (JFrame) getParent();
    parentFrame.setVisible(true);    
  }
<<<<<<< HEAD
}
=======



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

*/
}
>>>>>>> d17da96bb964643cf8480de34dde927e4c32b531
