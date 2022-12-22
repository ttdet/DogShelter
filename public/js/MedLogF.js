var MedLogF = MedLogF || {};

MedLogF.searchMedLogsForDogID = function(dogID) {
	return fetch('/SearchMedLogByDogID', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({DogID: dogID})
	})
	.then(response => response.json())
}

MedLogF.getMedLogByID = function(medLogID) {
	return fetch('/GetMedLogByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({medLog_id: medLogID})
	})
	.then(response => response.json())
}


MedLogF.createMedLogCard = function(medLogData) {
	console.log(medLogData);
	for(const k in medLogData) {
		if(medLogData[k] === null || medLogData[k] === undefined) {
			medLogData[k] = '-';
		}
	}

		const medLogCardHtml = `
		<div class="card medlog-card flex flex-col" style="width: 14rem;" id="medlog-card-${medLogData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#medlog-card-collapse-${medLogData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${medLogData.DogName}</h5>
				<p class="card-text">${medLogData.Date}</p>
				<p class="card-text">${medLogData.Time}</p>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="medlog-card-collapse-${medLogData.ID}" style="font-size: small;">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Medication: ${medLogData.MedName}</li>
					<li class="list-group-item">Amount: ${medLogData.Amount} ${medLogData.UnitPerStock}</li>
					<li class="list-group-item">Administered By: ${medLogData.VolunteerName}</li>
					<li class="list-group-item">Note: ${medLogData.Note}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateMedLogModal" onclick="retrieveMedLogInfo(${medLogData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${medLogData.ID})">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = MedLogF.htmlToElement(medLogCardHtml);

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

MedLogF.refreshMedLogCard = function(medLogId) {
	MedLogF.getMedLogByID(medLogId).then(rowset => {
		const medLogData = rowset[0];
		$(`#medlog-card-${medLogId}`).replaceWith(MedLogF.createMedLogCard(medLogData));
	});
}

MedLogF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}