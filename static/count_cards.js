/* count_cards.js */

var card_counts = {};
var suit_counts = {};

var denominations = ["ace", "ten", "king", "queen", "jack"];

function update_counts(event) {
    var target = event.target;
    var name = target.getAttribute("name");
    var suit = name.split('_')[1];
    var value = parseInt(target.getAttribute("value"));
    // alert(name + " " + suit + " " + value + " " + target.checked);
    card_counts[name] = value;
    sum_counts(suit);
    update_total();
}


function sum_counts(suit) {
    var sum = 0;
    for (den of denominations) {
        var key = den + "_" + suit;
        // alert(key + " " + (key in card_counts));
        sum += card_counts[key];
    }
    // alert(sum);
    suit_counts[suit] = sum;
    document.getElementById(suit).textContent = sum;
}


function update_total() {
    var total = suit_counts["hearts"] + suit_counts["spades"]
              + suit_counts["diamonds"] + suit_counts["clubs"];
    document.getElementById("total").textContent = total;
    if (total == 20) {
        // alert("disabled = false");
        document.getElementById("submit_button").disabled = false;
    } else {
        // alert("disabled = true");
        document.getElementById("submit_button").disabled = true;
    }
}
