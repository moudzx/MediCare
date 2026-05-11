(function () {

    window.saveFood = function () {
        alert("Saved to My Foods (connect DB later)");
    };

    window.resetForm = function () {
        document.getElementById("txtFood").value = "";
        document.getElementById("txtCalories").value = "";
        document.getElementById("txtProtein").value = "";
        document.getElementById("txtCarbs").value = "";
        document.getElementById("txtFat").value = "";
        document.getElementById("txtFiber").value = "";

        hideResult();
    };

    window.calculateAccuracy = function () {

        let cal = parseFloat(document.getElementById("txtCalories").value || 0);
        let protein = parseFloat(document.getElementById("txtProtein").value || 0);
        let carbs = parseFloat(document.getElementById("txtCarbs").value || 0);
        let fat = parseFloat(document.getElementById("txtFat").value || 0);
        let fiber = parseFloat(document.getElementById("txtFiber").value || 0);

        // Example "nutrition plan targets"
        let target = {
            calories: 400,
            protein: 30,
            carbs: 50,
            fat: 15,
            fiber: 8
        };

        let score = 0;

        score += scoreMetric(cal, target.calories);
        score += scoreMetric(protein, target.protein);
        score += scoreMetric(carbs, target.carbs);
        score += scoreMetric(fat, target.fat);
        score += scoreMetric(fiber, target.fiber);

        let accuracy = Math.max(0, Math.min(100, Math.round(score / 5)));

        showResult(`
            <b>Accuracy Score:</b> ${accuracy}%<br/>
            ${getFeedback(accuracy)}
        `);
    };

    function scoreMetric(value, target) {
        if (!target) return 0;
        let diff = Math.abs(target - value);
        return Math.max(0, 100 - (diff / target) * 100);
    }

    function getFeedback(score) {
        if (score >= 85) return "Excellent match with your nutrition plan.";
        if (score >= 60) return "Good, but slightly off balance.";
        return "Not aligned with your nutrition goals.";
    }

    function showResult(html) {
        let box = document.getElementById("resultBox");
        box.innerHTML = html;
        box.style.display = "block";
    }

    function hideResult() {
        let box = document.getElementById("resultBox");
        box.style.display = "none";
        box.innerHTML = "";
    }

})();