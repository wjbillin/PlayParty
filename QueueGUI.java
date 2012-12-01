package eecs285.proj4.naugust;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;
import javax.swing.SwingConstants;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;


public class QueueGUI extends JPanel
{
  
  private HomeActionListener myActionListener;
  private queueSelectListener queueListener;
  private JList<Song> queueList;             //CHANGE TO LIST OF SONGS
  private DefaultListModel<Song> listModel;  //CHANGE TO LIST OF SONGS
  private JLabel currentQueueStatus;
  private JList<Integer> numberList;
  private DefaultListModel<Integer> numberlistModel;
  
  public QueueGUI()
  {
    super();
    setLayout(new BorderLayout());
    myActionListener = new HomeActionListener();

    
    listModel = new DefaultListModel<Song>();    //CHANGE TO LIST OF SONGS
    queueList = new JList<Song>(listModel);   //CHANGE TO LIST OF SONGS
    numberlistModel = new DefaultListModel<Integer>();    //CHANGE TO LIST OF SONGS
    numberList = new JList<Integer>(numberlistModel);   //CHANGE TO LIST OF SONGS
    //listModel.addElement("EMPTY");
    //ListSelectionModel listSelectionModel = queueList.getSelectionModel();
    queueListener = new queueSelectListener();
    
    queueList.addListSelectionListener(queueListener);
    numberList.addListSelectionListener(queueListener);
    
    JPanel bothDiffsPanel = new JPanel(new BorderLayout());
   // bothDiffsPanel.setLayout(new GridLayout(1, 2));
    bothDiffsPanel.add(numberList, BorderLayout.WEST);
    bothDiffsPanel.add(queueList);
    
    currentQueueStatus = new JLabel("Current Queue: ", SwingConstants.CENTER);
    
    add(currentQueueStatus, "North");
    
    //add(numberList);
    //add(queueList);
    //add(bothDiffsPanel);
    
    add(new JScrollPane(bothDiffsPanel), BorderLayout.CENTER);
 
    for(int i = 0; i < 100; i++)
    {
      Song song = new Song("Blind", "JSON Derulo", "", "");
      listModel.addElement(song);
      numberlistModel.addElement(i+1);
    }
    
    
    
  }
  
  public class HomeActionListener implements ActionListener
  {
    public void actionPerformed(ActionEvent event)
    {
      
    }
  }
  
  public class queueSelectListener implements ListSelectionListener
  {
    public void valueChanged(ListSelectionEvent e)
    {
      if(e.getSource().equals(queueList))
      {
        numberList.setSelectedIndex(queueList.getSelectedIndex());
      }
      if(e.getSource().equals(numberList))
      {
        queueList.setSelectedIndex(numberList.getSelectedIndex());
      }
   
    }
  }
  
  
  
  
  
  
  
  
  
}