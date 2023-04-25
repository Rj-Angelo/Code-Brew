//= require jquery3
let editor;
let playbackEvents = [];
let completed_puzzles = gon.completed_puzzles;
console.log(completed_puzzles);
$(document).ready(() => {
	let keystrokes = [];

	//set editor values and start
	editor = ace.edit("code_area");
	editor.setTheme("ace/theme/monokai");
	editor.getSession().setMode("ace/mode/ruby");
	editor.setOptions({
		showPrintMargin: false,
	});
	editor.setValue("",-1);
	editor.focus();

	record();

	//process user submitted data and stop playback once user has passed test cases
	$("form#user_input").submit((e) => {
		$("#code").val(editor.getValue());
		
		e.preventDefault();

		let data = {
			form: $(e.target).serialize(),
			playback: JSON.stringify(keystrokes),
		}

		$.post($(e.target).attr("action"),data,function(res){			
			if(!res.error){
				$("#playbacks").prepend(res.html);
				for(let i=0; i<res.status.length; i++){
					$(`p#case${i}-console`).text("");
					$("#console-errors").text("");
					$(`p#case${i}`).attr("class", res.status[i]);
					$(`p#case${i}-console`).text(res.console[i]);
				}
				completed_puzzles.push(res.completed_puzzle);
			}else{
				$("#console-errors").text(res.error);
			}

			if(res.completed){
				editor.off("change",recordKeystroke);	
			}
		});
		editor.focus();
	});

	//submit user forum post and render post partial
	$("form#post").submit((e) => {
		e.preventDefault();

		$.post($(e.target).attr("action"),$(e.target).serialize(),function (res) {
			if(res.errors){
				$("#new_post").addClass("is-invalid");
				$("#post_errors").text(res.errors);
			}else{
				$("#new_post").val("");
				$("#post_errors").text("");
				$("#posts").prepend(res.html);
			}
		});

		return false;
	});

	//submit edit form --Currently not working
	$("form.edit_post").submit((e) => {
		e.preventDefault();

		$.post($(e.target).attr("action"),$(e.target).serialize(),function(res){
			if(res.errors){
				$(e.target).siblings("p.fail").val(res.errors);
				$(e.target).find("text_area").focus();
			}
		});
	});

	$(document).on("click",".delete_post",(e) => {
		$(e.target).parent().remove();
	});

	//enable editing of post
	$(document).on("click",".edit_post",(e) => {
		e.preventDefault();
		
		var form = $(e.target).siblings("form");
		//target text area
		$(form[0][2]).prop("disabled", false);
		$(form[0][2]).focus();
	});

	//edit post if focus is lost
	$("textarea.post_content").on("blur", (e)=>{
		$(e.target).parent().submit();
	});

	//capture user keystrokes
	function recordKeystroke(e) {
		var keyEvent = {
			'data': e,
			'timestamp': Date.now()
		};

		keystrokes.push(keyEvent);
	}

	//capture user inputs
	function captureState() {
		var keyEvent = {
			'data': {
				'action': 'insert',
				'text': editor.getValue()
			},
			'timestamp': Date.now()
		};

		keystrokes.push(keyEvent);
	}

	//record user keystrokes
	function record() {
		captureState();
		editor.on("change",recordKeystroke);
	}
});

function stop() {
	editor.off("change",recordKeystroke);
	editor.setReadOnly(false);

	if (playbackEvents[0]) {
		for (i = 0; i < playbackEvents.length; i++) {
			clearTimeout(playbackEvents[i]);
		}
	}
}

function play(id) {
	//get keystrokes of completed puzzle
	let keystrokes = completed_puzzles[id].playback
	let startTime = keystrokes[0].timestamp,
		i = 0;

	//reset editor to base values and turn it to read only to start playback
	editor.setValue("");
	editor.setReadOnly(true);
	editor.clearSelection();

	//start replay
	for (i = 0; i < keystrokes.length; i++) {
		createEvent(startTime,i,keystrokes);
	}

}

//create playback with user keystrokes
function createEvent(starttime,i,keystrokes) {
	let k = keystrokes[i],
		dT = 1;

	let evt = setTimeout(function () {

		editor.clearSelection();
		let actions = {
			"insert": () => {
				for (let i = 0; i < k.data.lines.length; i++) {
					editor.insert(k.data.lines[i]);
					if (i < k.data.lines.length - 1) {
						editor.insert("\n");
					}
				}
			},
			"remove": () => {
				let range = {
					"start": {
						"row": k.data.start.row,
						"column": k.data.start.column
					},

					"end": {
						"row": k.data.end.row,
						"column": k.data.end.column
					}
				}
				editor.getSession().remove(range);
			}
		};
		actions[k.data.action]();

		if (i == keystrokes.length - 1) {
			editor.setReadOnly(false);
		}

	},dT * (keystrokes[i].timestamp - starttime));

	playbackEvents.push(evt);
}