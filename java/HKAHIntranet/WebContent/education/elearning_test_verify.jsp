<%
response.setHeader("Pragma","no-cache");

String questionPointer = request.getParameter("qpi");
String elearningAID = request.getParameter("aid");
int questionPointerInt = 0;
boolean correct = false;

try {
	if (questionPointer != null) {
		questionPointerInt = Integer.parseInt(questionPointer);
	}

	String[][] answersCorrect = (String[][]) session.getAttribute("elearning.answersCorrect");

	for (int i = 0; !correct && i < answersCorrect[questionPointerInt].length; i++) {
		if (answersCorrect[questionPointerInt][i].equals(elearningAID)) {
			correct = true;
		}
	}
} catch (Exception e) {
}

if (correct) {
	out.print("1");
} else {
	out.print("0");
}
%>