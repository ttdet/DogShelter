var FoodF = FoodF || {};


FoodF.searchFoodByName = function(foodNameSearch) {
    return fetch('/SearchFoodByName', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({name_search: foodNameSearch})
	})
	.then(response => response.json())
}

FoodF.fetchAllFood = function() {
	return fetch('/FetchAllFood', {
		method: 'POST'
	}).then(response => response.json())
}

FoodF.searchFoodByID = function(foodID) {
	return fetch('/SearchFoodByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({food_id: foodID})
	})
	.then(response => response.json())
}

FoodF.createFoodCard = function(foodData) {
	console.log(foodData);
	for(const k in foodData) {
		if(foodData[k] === null || foodData[k] === undefined) {
			foodData[k] = '-';
		}
	}

	const foodCardHtml = `
		<div class="card food-card flex flex-col" style="width: 14rem;" id="food-card-${foodData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#food-card-collapse-${foodData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${foodData.Name}</h5>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="food-card-collapse-${foodData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Instructions: ${foodData.Instructions}</li>
					<li class="list-group-item">Bought From: ${foodData.boughtFrom}</li>
					<li class="list-group-item">Stock: ${foodData.Stock}</li>
					<li class="list-group-item">Units: ${foodData.UnitPerStock}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateFoodModal" onclick="retrieveFoodInfo(${foodData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${foodData.ID}, '${foodData.Name}')">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = FoodF.htmlToElement(foodCardHtml);

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

FoodF.refreshFoodCard = function(foodId) {
	FoodF.searchFoodByID(foodId).then(rowset => {
		const foodData = rowset[0];
		$(`#food-card-${foodId}`).replaceWith(FoodF.createFoodCard(foodData));
	});
}

FoodF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}

