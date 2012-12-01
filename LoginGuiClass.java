package eecs285.proj4.naugust;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;


public class LoginGuiClass extends JDialog {//implements WindowListener {

  private JLabel UserName;
  private JLabel PassWord;
  private JTextField UN;
  private JPasswordField PW;
  private JButton LogIn;
  private JButton back;
  private ActionListener ButListener;
  private ActionListener EnterListener;
  private ActionListener backButtonListener;
  private JFrame parent;

  
  public LoginGuiClass(JFrame homeFrame, String title) {

        super(homeFrame, title, true);
        setDefaultCloseOperation(HIDE_ON_CLOSE);
    setResizable(false);
        setLocationRelativeTo(homeFrame);
      //  addWindowListener(this);
        
    parent = new JFrame();
    parent = homeFrame;    
    
    UserName = new JLabel("User Name: ");
    PassWord = new JLabel("Password:  ");
    
    UN = new JTextField(20);
    PW = new JPasswordField(20);
    EnterListener = new LoginListener();
    PW.addActionListener(EnterListener);
    
    setLayout(new BorderLayout());
    JPanel top = new JPanel(new FlowLayout());
    JPanel mid = new JPanel(new FlowLayout());
    JPanel bot = new JPanel(new FlowLayout());
    
    top.add(UserName);
    top.add(UN);
    mid.add(PassWord);
    mid.add(PW);
    
    
        back = new JButton("Back");
        backButtonListener = new BackListener();
        back.addActionListener(backButtonListener);
        bot.add(back);
    LogIn = new JButton("Log In");
    ButListener = new LoginListener();
    LogIn.addActionListener(ButListener);
    bot.add(LogIn);
    
    add(top, BorderLayout.NORTH);
    add(mid, BorderLayout.CENTER);
    add(bot, BorderLayout.SOUTH);
    pack();

    
  }
  
  
  public class LoginListener implements ActionListener {

    public void actionPerformed(ActionEvent e) {
      boolean isCorrect = false;
      String user = UN.getText();
      char[] temp = PW.getPassword();
      String pass =  new String(temp);
      
      int x = 0;
      while (x < temp.length) {
        temp[x] = 0;
        x++;
      }
          PW.setText("");

      System.out.print("Logging In: " + user + "\n" + 
        "With the password: " + pass + "\n");
      
      
      // get the information form the text fields and try to login.
      // if successful login open new gui for host or join
      // if fail pop up error and have the user try again
      isCorrect = true;
      sessionData dataBack = new sessionData("test");
      if (isCorrect) {
        setVisible(false); 
        //new ControlPannelGuiClass(LoginGuiClass.this, user + "'s party", true, dataBack).setVisible(true);
        new Tab(LoginGuiClass.this.getName(), false);
        parent.dispose();
      }
      
      pass = "";
    } 
  }
  
  public class BackListener implements ActionListener {

        public void actionPerformed(ActionEvent e) {
          UN.setText("");
          PW.setText("");
          setVisible(false);
          dispose();
        }
  }
/*
  @Override
  public void windowClosed(WindowEvent arg0) {
    JFrame parentFrame = (JFrame) getParent();
    parentFrame.setVisible(true);
    
  }

  @Override
  public void windowActivated(WindowEvent e) {
    // TODO Auto-generated method stub
    
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
    
  }*/
}
