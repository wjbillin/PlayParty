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
  private ButtonListener buttonListener;
  //private ActionListener cancelButtonListener;
  //private ActionListener refreshButtonListener;
  private boolean refreshBeenPushed = false;
  private JFrame parent;

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

    buttonListener = new ButtonListener();
    partyList = new DefaultListModel();
    listedItems = new JList(partyList);
    listedItems.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    listedItems.setLayoutOrientation(JList.VERTICAL);


    largerPanel = new Panel();
    refresh = new JButton("Refresh list");
    refresh.addActionListener(buttonListener);
    largerPanel.add(refresh);

    add(largerPanel, BorderLayout.NORTH);

    add(listedItems, BorderLayout.CENTER);
    partyList.addElement("Click the refresh button");

    buttonPanel = new Panel();
    join = new JButton("Join Session");
    join.addActionListener(buttonListener);
    buttonPanel.add(join);
    cancel = new JButton("Cancel");
    cancel.addActionListener(buttonListener);
    buttonPanel.add(cancel);

    add(buttonPanel, "South");
    //largerPanel.add(buttonPanel);
    //add(largerPanel, BorderLayout.SOUTH);
    pack();



    //****************/

  }

  private void refreshList(){
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

  public class ButtonListener implements ActionListener {
    public void actionPerformed(ActionEvent e) {

      if (e.getSource().equals(join)) {
        if (refreshBeenPushed) {
          sessionData selectedInList = behindDisplay.get(listedItems.getSelectedIndex());
          System.out.println("Joining: " + selectedInList.getName());
          setVisible(false);
          new Tab(selectedInList.getName(), true);
          parent.dispose();
        } else{
           refreshList();
        }
      }
      else if (e.getSource().equals(cancel)) {
        setVisible(false);
        dispose();
      }
      else if (e.getSource().equals(refresh)) {
        refreshList();
      }
    }
  }
}