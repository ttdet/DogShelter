var MealLogF = MealLogF || {};


MealLogF.searchMealLogByDogID = function(dogID) {
	return fetch('/SearchMealLogByDogID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({dog_id: dogID})
	})
	.then(response => response.json());
}

MealLogF.fetchAllMealLog = function() {
	return fetch('/FetchAllMealLog', {
		method: 'POST'
	})
	.then(response => response.json())
}

MealLogF.createMealLogCard = function(mealLogData) {
	for(const k in mealLogData) {
		if(mealLogData[k] === null || mealLogData[k] === undefined) {
			mealLogData[k] = '-';
		}
	}

	const MealLogCardHtml = `
		<div class="card MealLog-card flex flex-col" style="width: 14rem;" id="MealLog-card-${mealLogData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#MealLog-card-collapse-${mealLogData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${mealLogData.DogName}</h5>
				<p class="card-text">${mealLogData.Date}</p>
				<p class="card-text">${mealLogData.Time}</p>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="MealLog-card-collapse-${mealLogData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Food: ${mealLogData.FoodName}</li>
					<li class="list-group-item">Amount: ${mealLogData.Amount}</li>
					<li class="list-group-item">Note: ${mealLogData.Note}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateMealLogModal" onclick="retrieveMealLogInfo(${mealLogData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${mealLogData.ID})">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = MealLogF.htmlToElement(MealLogCardHtml);

	element.addEventListener('hidden.bs.collapse', function () {
		element.classList.remove("row-span-4");
	});
	
	element.addEventListener('show.bs.collapse', function () {
		element.classList.add("row-span-4");

		$(element).find(".collapse-arrow").addClass("arrow-expanded");
	});

	element.addEventListener('hide.bs.collapse', function () {
		$(element).find(".collapse-arrow").removeClass("arrow-expanded");
	});
	
	return element;
}

MealLogF.searchMealLogByID = function(id) {
	return fetch('/SearchMealLogByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({MealLogID: id})
	})
	.then(response => response.json())
}

MealLogF.refreshMealLogCard = function(MealLogID) {
	MealLogF.searchMealLogByID(MealLogID).then(rowset => {
		const data = rowset[0];
		$(`#MealLog-card-${MealLogID}`).replaceWith(MealLogF.createMealLogCard(data));
	});
}

MealLogF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}