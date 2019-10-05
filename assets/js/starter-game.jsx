import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

var TO_State = false;

export default function game_init(root, channel) {
  ReactDOM.render(<Starter channel={channel} />, root);
}

class Starter extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = { click_num: 0 };
    this.channel
        .join()
        .receive("ok", this.initGame.bind(this))
        .receive("error", resp => {console.log("Unable to join", resp); });
  }

  initGame(pros){
    this.setState({click_num: pros.click});
    let matched_id = pros.matched_id;
    let shown_id = pros.shown_id;
    var i;
    for (i = 0; i < matched_id.length; i++) {
      console.log("matched", matched_id[i]);
      document.getElementById(matched_id[i]).className = "matched";
    }
    for (i = 0; i < shown_id.length; i++){
      document.getElementById(shown_id[i]).className = "clicked";
      this.getChar(shown_id[i]);
    }
    console.log("game connected");
  }

  showChar(target){
    target.className = "clicked";
    this.getChar(target.id);
  }

  getChar(id){
    this.channel.push("getchar", {id: id})
        .receive("ok", (reps) => {document.getElementById(id).children[0].innerHTML = reps.char})
  }  

  checkMatch(click1, click2){
    if (click1.children[0].innerHTML == click2.children[0].innerHTML){
      click1.className = "matched";
      click2.className = "matched";
      click1.children[0].innerHTML = "";
      click2.children[0].innerHTML = "";
      this.channel.push("match", {matched_id: [click1.id, click2.id]})
        .receive("ok", () => {console.log("matched_id updated")})
      if (document.getElementsByClassName("notmatch").length === 0){
        alert("Congratulations!! You have passed the game!! Press the button to play again.");
      }
    } 
    else{
      click1.className = "notmatch";
      click2.className = "notmatch";
      click1.children[0].innerHTML = "";
      click2.children[0].innerHTML = "";
      this.channel.push("notmatch", {})
        .receive("ok", () => {console.log("shown_id updated")})
    }
    TO_State = false;
  }
  tileClick(ev){
    if (!TO_State){
   //when the tile doesn't have a matched tile
    if (ev.target.className === "notmatch"){
      // click number plus 1
      let count = this.state.click_num + 1;
      this.setState({click_num: count});
      let id = ev.target.id;
      this.channel.push("click", {id: id, click: count})
        .receive("ok", () => {console.log("updated")})
      if (document.getElementsByClassName("clicked").length === 0){
        this.showChar(ev.target);
      }
      else{
        TO_State = true;
        let click1 = document.getElementsByClassName("clicked")[0];
        this.showChar(ev.target);
        let click2 = ev.target;
        setTimeout(this.checkMatch.bind(this,click1,click2),1000);
      }
    //  ev.target.style.backgroundColor = "white";
    }
  }
  }

  restart(ev){
    if (!TO_State){
      let tds = document.getElementsByTagName("td");
      for (let i = 0; i < tds.length; i++){
        tds[i].className = "notmatch";
        tds[i].children[0].innerHTML = "";
      }
      this.setState({click_num: 0});
      this.channel.push("restart")
          .receive("ok", () => {console.log("game restarted")})
    }
  }
 
  render() {
    return(
   <div>
   <div>
    <table>
    <tbody>
    <tr>
        <td id ="1" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "2" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "3" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "4" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
    </tr>
    <tr>
        <td id = "5" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "6" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "7" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "8" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
    </tr>
    <tr>
        <td id = "9" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "10" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "11" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "12" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
    </tr>
    <tr>
        <td id = "13" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "14" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "15" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
        <td id = "16" className = "notmatch" onClick = {this.tileClick.bind(this)}><p></p></td>
    </tr>
    </tbody>
    </table>
  </div>
  <div><p>Number of Click: {this.state.click_num}</p></div>
  <div className = "row">
    <button type = "button" onClick = {this.restart.bind(this)}>Start Game!</button>
  </div>
  </div>
 
);
}

}
