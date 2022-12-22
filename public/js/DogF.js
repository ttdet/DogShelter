var DogF = DogF || {};

DogF.fetchAllDog = function() {
	return fetch('/FetchAllDog', {
		method: 'POST', 
	}).then(response => response.json());
}

DogF.searchDogByID = function(dogID) {
	return fetch('/SearchDogByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({dog_id: dogID})
	})
	.then(response => response.json())
}

DogF.searchDogByName = function(dogName) {
    return fetch('/SearchVolunteerByName', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({dog_name: dogName})
	})
	.then(response => response.json())
}

DogF.createDogCard = function(dogData) {
	
	for(const k in dogData) {
		if(dogData[k] === null || dogData[k] === undefined) {
			dogData[k] = '-';
		}
	}

	const dogCardHtml = `
		<div class="card dog-card flex flex-col" style="width: 14rem;" id="dog-card-${dogData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#dog-card-collapse-${dogData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${dogData.Name}</h5>
				<p class="card-text">${dogData.Breed}</p>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="dog-card-collapse-${dogData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Sex: ${dogData.Sex}</li>
					<li class="list-group-item">Weight: ${dogData.WeightInlbs} lbs</li>
					<li class="list-group-item">Spayed/neutered?: ${dogData.hasBeenSpayed}</li>
					<li class="list-group-item">Age: ${dogData.Age} years old</li>
					<li class="list-group-item">Information: ${dogData.Information}</li>
					<li class="list-group-item">General Instruction: ${dogData.GeneralInstruction}</li>
					<li class="list-group-item">Feed Instruction: ${dogData.FeedInstruction}</li>
					<li class="list-group-item dropdown">
					<a class="dropdown-toggle" type="button" id="dropdown-menu-${dogData.ID}" data-bs-toggle="dropdown" aria-expanded="false" style="text-decoration:none">Add log</a>
						<ul class="dropdown-menu" aria-labelledby="dropdown-menu-${dogData.ID}">
							<li><a class="dropdown-item" type="button" href="/bathroomLog?addForID=${dogData.ID}">Bathroom log</a></li>
							<li><a class="dropdown-item" type="button" href="/mealLog?addForID=${dogData.ID}">Meal log</a></li>
							<li><a class="dropdown-item" type="button" href="/medLog?addForID=${dogData.ID}">Med log</a></li>
						</ul>
					</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateDogModal" onclick="retrieveDogInfo(${dogData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${dogData.ID}, '${dogData.Name}')">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = DogF.htmlToElement(dogCardHtml);

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

DogF.refreshDogCard = function(dogId) {
	DogF.searchDogByID(dogId).then(rowset => {
		const dogData = rowset[0];
		$(`#dog-card-${dogId}`).replaceWith(DogF.createDogCard(dogData));
	});
}

DogF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}