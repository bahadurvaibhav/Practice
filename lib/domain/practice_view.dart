import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/form.dart';
import 'package:practice/database/question.dart';
import 'package:practice/database/question_answer.dart';
import 'package:practice/domain/enum/question_type.dart';
import 'package:practice/domain/enum/skill_type.dart';
import 'package:practice/util/utility.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PracticePage extends StatefulWidget {
  final SkillType skillType;
  final int formId;

  PracticePage({Key key, @required this.skillType, this.formId})
      : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  DatabaseHelper helper = DatabaseHelper.instance;
  var questionAnswers = new Map();
  var serverQuestionAnswers = new Map();
  bool readOnly = false;
  var questionIdImageUrl = new Map();

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  YoutubePlayerController _youtubePlayerController;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: 'WK8qRNSmhEU',
      flags: YoutubePlayerFlags(
        mute: true,
        autoPlay: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);
    super.initState();
    _videoMetaData = YoutubeMetaData();
    if (widget.formId != null) {
      getQuestionAnswers(widget.formId);
    }
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !_youtubePlayerController.value.isFullScreen) {
      setState(() {
        _videoMetaData = _youtubePlayerController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.pause();
    }
    if (_youtubePlayerController != null) {
      _youtubePlayerController.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    if (_youtubePlayerController != null) {
      _youtubePlayerController.dispose();
    }
    super.dispose();
  }

  getQuestionAnswers(int formId) {
    helper.getQuestionAnswersByFormId(formId).then((value) {
      if (value != null) {
        value.forEach((questionAnswer) {
          serverQuestionAnswers[questionAnswer.questionId] =
              questionAnswer.answer;
        });
        setState(() {
          readOnly = true;
        });
      }
    });
  }

  submit() {
    String createdAt = getDateNow();
    PracticeForm newForm = new PracticeForm(widget.skillType, createdAt);
    var formId;
    helper.insertForm(newForm).then((value) {
      formId = value;
      questionAnswers.forEach((key, value) {
        QuestionAnswer questionAnswer =
            new QuestionAnswer(key, value.toString(), formId);
        helper.insertQuestionAnswer(questionAnswer);
      });
    });
    Navigator.pop(context);
  }

  showQuestionsAndSubmit(List<Question> questions) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              shrinkWrap: true,
              children: showQuestionnaire(questions),
            ),
          ),
        ),
        showSubmit(),
      ],
    );
  }

  showQuestionnaire(List<Question> questions) {
    List<Widget> items = new List<Widget>();
    questions.forEach((question) {
      items.add(showQuestion(question));
    });
    return items;
  }

  showSubmit() {
    if (!readOnly) {
      return FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        splashColor: Colors.blueAccent,
        onPressed: () => submit(),
        child: Text('Submit'),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  showQuestion(Question question) {
    switch (question.questionType) {
      case QuestionType.ANSWER_TEXT:
        return answerText(question);
        break;
      case QuestionType.RATING:
        return rating(question);
        break;
      case QuestionType.EXPANDABLE_ANSWER_TEXT:
        return expandableAnswerText(question);
        break;
      case QuestionType.TEXT:
        return text(question);
        break;
      case QuestionType.IMAGE_URL:
        return imageUrl(question);
        break;
      case QuestionType.VIDEO_URL:
        return videoUrl(question);
        break;
    }
  }

  getOuterStyle(question, answerField) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(question.description),
          answerField,
        ],
      ),
    );
  }

  videoUrl(question) {
    var pasteIconWidget = getPasteIconWidget(question, readOnly);
    var videoWidget = getVideoWidget(question);
    return getUrlWidget(question, pasteIconWidget, videoWidget);
  }

  imageUrl(question) {
    var pasteIconWidget = getPasteIconWidget(question, readOnly);
    var imageWidget = getImageWidget(question);
    return getUrlWidget(question, pasteIconWidget, imageWidget);
  }

  getUrlWidget(question, suffixIcon, contentWidget) {
    return getOuterStyle(
        question,
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: new InputDecoration(
                        hintText: serverQuestionAnswers[question.id],
                        suffixIcon: suffixIcon),
                    onChanged: (text) {
                      questionAnswers[question.id] = text;
                    },
                  ),
                ),
              ],
            ),
            contentWidget,
          ],
        ));
  }

  getVideoWidget(question) {
    if (questionIdImageUrl[question.id] == null) {
      return SizedBox.shrink();
    } else {
      String videoUrl = questionIdImageUrl[question.id];
      if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
        return getYoutubeVideoPlayer(videoUrl);
      } else {
        return getVideoPlayer(videoUrl);
      }
    }
  }

  getYoutubeVideoPlayer(String videoUrl) {
    // TODO: If user enters another URL on top, load that one

    String videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return Column(
      children: <Widget>[
        YoutubePlayer(
          controller: _youtubePlayerController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          onReady: () {
            print('youtube player is ready');
            _isPlayerReady = true;
            _youtubePlayerController.load(videoId);
          },
          topActions: <Widget>[
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _videoMetaData.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
          bottomActions: [
            CurrentPosition(),
            SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            SizedBox(width: 10.0),
            RemainingDuration(),
            FullScreenButton(),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  _youtubePlayerController.mute();
                },
                child: Icon(Icons.volume_off),
              ),
            ),
            Container(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  _youtubePlayerController.unMute();
                },
                child: Icon(Icons.volume_up),
              ),
            ),
          ],
        )
      ],
    );
  }

  getVideoPlayer(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  if (!_controller.value.isPlaying) {
                    _controller.play();
                  }
                },
                child: Icon(Icons.play_arrow),
              ),
            ),
            Container(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                },
                child: Icon(Icons.pause),
              ),
            ),
            Container(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  _controller.setVolume(0.0);
                },
                child: Icon(Icons.volume_up),
              ),
            ),
            Container(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                color: Colors.amber,
                textColor: Colors.white,
                splashColor: Colors.amberAccent,
                onPressed: () {
                  _controller.setVolume(1.0);
                },
                child: Icon(Icons.volume_off),
              ),
            ),
          ],
        ),
      ],
    );
  }

  getImageWidget(question) {
    return questionIdImageUrl[question.id] == null
        ? SizedBox.shrink()
        : Stack(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              )),
              Center(
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: questionIdImageUrl[question.id]),
              )
            ],
          );
  }

  getPasteIconWidget(question, bool isRead) {
    var pasteIconWidget;
    if (readOnly) {
      questionIdImageUrl[question.id] = serverQuestionAnswers[question.id];
      pasteIconWidget = SizedBox.shrink();
    } else {
      pasteIconWidget = IconButton(
        icon: Icon(Icons.content_paste),
        color: Colors.amber,
        onPressed: () async {
          ClipboardData data = await Clipboard.getData('text/plain');
          questionAnswers[question.id] = data.text;
          setState(() {
            serverQuestionAnswers[question.id] = data.text;
            questionIdImageUrl[question.id] = data.text;
          });
        },
      );
    }
    return pasteIconWidget;
  }

  answerText(question) {
    return getOuterStyle(
        question,
        TextField(
          enabled: !readOnly,
          decoration:
              new InputDecoration(hintText: serverQuestionAnswers[question.id]),
          onChanged: (text) {
            questionAnswers[question.id] = text;
          },
        ));
  }

  rating(question) {
    var widget;
    if (readOnly) {
      var ratingBar = RatingBar(
        initialRating: getDouble(serverQuestionAnswers[question.id]),
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          questionAnswers[question.id] = rating;
        },
      );
      widget = new FocusScope(node: new FocusScopeNode(), child: ratingBar);
    } else {
      widget = RatingBar(
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          questionAnswers[question.id] = rating;
        },
      );
    }
    return getOuterStyle(question, widget);
  }

  expandableAnswerText(question) {
    return getOuterStyle(
        question,
        TextField(
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: null,
          enabled: !readOnly,
          decoration:
              new InputDecoration(hintText: serverQuestionAnswers[question.id]),
          onChanged: (text) {
            questionAnswers[question.id] = text;
          },
        ));
  }

  text(question) {
    return getOuterStyle(question, new Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
      ),
      body: FutureBuilder<List<Question>>(
        future: helper.getQuestionsBySkill(widget.skillType),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return showQuestionsAndSubmit(snapshot.data);
        },
      ),
    );
  }
}
