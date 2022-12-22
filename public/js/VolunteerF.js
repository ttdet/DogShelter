var VolunteerF = VolunteerF || {};

VolunteerF.fetchAllVolunteer = function() {
	return fetch('/FetchAllVolunteer', {
		method: 'POST', 
	}).then(response => response.json());
}


VolunteerF.searchVolunteerByName = function(volunteerNameSearch) {
    return fetch('/SearchVolunteerByName', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({name_search: volunteerNameSearch})
	})
	.then(response => response.json())
}

VolunteerF.searchVolunteerByID = function(volunteerID) {
	return fetch('/SearchVolunteerByID', {
		method: 'POST',
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({volunteer_id: volunteerID})
	})
	.then(response => response.json())
}


VolunteerF.createVolunteerCard = function(volunteerData) {
	console.log(volunteerData);
	for(const k in volunteerData) {
		if(volunteerData[k] === null || volunteerData[k] === undefined) {
			volunteerData[k] = '-';
		}
	}

	const volunteerCardHtml = `
		<div class="card volunteer-card flex flex-col" style="width: 14rem;" id="volunteer-card-${volunteerData.ID}">
			<div class="card-body" data-bs-toggle="collapse" data-bs-target="#volunteer-card-collapse-${volunteerData.ID}" aria-expanded="false" style="cursor: pointer;">
				<h5 class="card-title">${volunteerData.FirstName} ${volunteerData.LastName}</h5>
				<span class="collapse-arrow">›</span>
			</div>
			<div class="collapse" id="volunteer-card-collapse-${volunteerData.ID}" style="font-size : small">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">Sex: ${volunteerData.Sex}</li>
					<li class="list-group-item">Can give medication: ${volunteerData.CanGiveMed}</li>
					<li class="list-group-item">Age: ${volunteerData.Age}</li>
					<li class="list-group-item">Member since: ${volunteerData.MemberSince.substring(0, 10)}</li>
					<li class="list-group-item">Service ends on: ${volunteerData.ServicesEndOn.substring(0, 10)}</li>
				</ul>
				<div class="card-body">
					<a class="card-link" data-bs-toggle="modal" href="#updateVolunteerModal" onclick="retrieveVolunteerInfo(${volunteerData.ID})">Edit</a>
					<a class="card-link text-danger" data-bs-toggle = "modal" href="#confirmDeletionModal" onclick="prepareDeletion(${volunteerData.ID}, '${volunteerData.FirstName} ${volunteerData.LastName}')">Delete</a>
				</div>
			</div>
		</div>`;
	
	const element = VolunteerF.htmlToElement(volunteerCardHtml);

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

VolunteerF.refreshVolunteerCard = function(volunteerId) {
	VolunteerF.searchVolunteerByID(volunteerId).then(rowset => {
		const volunteerData = rowset[0];
		$(`#volunteer-card-${volunteerId}`).replaceWith(VolunteerF.createVolunteerCard(volunteerData));
	});
}

VolunteerF.htmlToElement = function(html) {
	var template = document.createElement('template');
	html = html.trim();
	template.innerHTML = html;
	return template.content.firstChild;
}