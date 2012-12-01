package eecs285.proj4.naugust;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ListModel;


/**
 * Created with IntelliJ IDEA.
 * User: Savannah
 * Date: 11/30/12
 * Time: 6:00 PM
 * To change this template use File | Settings | File Templates.
 */
public class LibraryGUI extends JPanel {

  LibraryGUI (){
    super();

    setLayout(new BorderLayout());
    actionListener = new CPActionListener();
    search = new JButton("Go");
    search.addActionListener(actionListener);
    searchField = new JTextField();
    searchField.setPreferredSize(new Dimension(120, 20));
    listModel = new DefaultListModel<Song>();

    songList = new SongList();
    songJList = new JList<Song>(listModel);
    currentSongLabel = new JLabel("No song playing");
    sortBox = new JComboBox<String>(Song.sortStrings);
    sortBox.setSelectedItem(null);
    sortBox.addActionListener(actionListener);
    searchBy = new JComboBox<String>(Song.sortStrings);
    searchBy.addActionListener(actionListener);

    addSongButton = new JButton("Add Song to Queue");
    addSongButton.addActionListener(actionListener);
    partyButton = new JButton("Join Party");
    partyButton.addActionListener(actionListener);
    currentPartyLabel = new JLabel(currentParty);

    JPanel panel1 = new JPanel(new FlowLayout());
    panel1.add(new JLabel("Currently Listening to: "));
    panel1.add(currentSongLabel);
    JPanel panel2 = new JPanel(new FlowLayout());
    panel2.add(new JLabel("Sort By: "));
    panel2.add(sortBox);
    panel2.add(new JLabel("Search By: "));
    panel2.add(searchBy);
    panel2.add(searchField);

    JPanel topPanel = new JPanel(new BorderLayout());
    topPanel.add(panel1, BorderLayout.NORTH);
    topPanel.add(panel2, BorderLayout.SOUTH);
    add(topPanel, BorderLayout.NORTH);

    JPanel bottomPanel = new JPanel(new FlowLayout());
    bottomPanel.add(addSongButton);
    bottomPanel.add(partyButton);
    bottomPanel.add(new JLabel("Current Party: "));
    bottomPanel.add(currentPartyLabel);

    add(new JScrollPane(songJList));
    add(bottomPanel, BorderLayout.SOUTH);
    
    for(int i = 0; i < 100; i++)
    {
      Song song = new Song("Blind", "JSON Derulo", "", "");
      listModel.addElement(song);
     // numberlistModel.addElement(i+1);
    }
  }

  private void updateJList(SongList songlist){
    listModel.removeAllElements();
    for(int i = 0; i < songList.size(); i++){
      listModel.addElement(songlist.get(i));
    }
  }

  public class CPActionListener implements ActionListener {
    public void actionPerformed(ActionEvent event){
      if(event.getSource().equals(sortBox)){
        songList.sortSongList(Song.sortStrings[sortBox.getSelectedIndex()]);
        updateJList(songList);
      } else if(event.getSource().equals(search)){
        SongList filteredList = (songList.searchFilter(Song.sortStrings[searchBy.getSelectedIndex()], searchField.getText()));
        updateJList(filteredList);
      }

    }
  }

  private SongList songList;
  private JList<Song> songJList;
  private JComboBox<String> sortBox;
  private JComboBox<String> searchBy;
  private JTextField searchField;
  private JButton search;
  private DefaultListModel<Song> listModel;
  private JLabel currentSongLabel;
  private String currentSong;
  private CPActionListener actionListener;
  private JButton addSongButton;
  private JButton partyButton;
  private JLabel currentPartyLabel;
  private String currentParty;
}