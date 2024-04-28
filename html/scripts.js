document.addEventListener('DOMContentLoaded', () => {
    let menuActive = false;

    const body = document.querySelector('body');
    const container = document.getElementById('container');
    const propNameInput = document.getElementById('propName');
    const spawnButton = document.getElementById('spawnButton');
    const closeButton = document.getElementById('closeButton');
    const moveButton = document.getElementById('moveButton');
    const deleteButton = document.getElementById('deleteButton');
    const propListButton = document.getElementById('propListButton');
    const propInfoContainer = document.getElementById('propInfoContainer');
    const propListContainer = document.getElementById('propListContainer');

    propListButton.addEventListener('click', () => {
        postMessageToClient('showPropList');
    });

    deleteButton.addEventListener('click', () => {
        closeMenu(); 
        postMessageToClient('deleteProp');
    });

    moveButton.addEventListener('click', () => {
        closeMenu(); 
        postMessageToClient('moveProp');
    });

    spawnButton.addEventListener('click', () => {
        if (propNameInput.value.trim() !== '') {
            const propName = propNameInput.value.trim();
            postMessageToClient('spawnProp', { propName });
            closeMenu();

        }
    });
    
    closeButton.addEventListener('click', () => {
        menuActive = false;
        postMessageToClient('closeMenu');
    });
    
    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && menuActive) {
            menuActive = false;
            postMessageToClient('closeMenu');
        }
    });
    
    window.addEventListener('message', (event) => {
        switch (event.data.type) {
        case 'toggleMenu':
            menuActive = event.data.menuActive; 
            body.style.display = menuActive ? 'block' : 'none';
            container.classList.toggle('hidden', !menuActive);
            if (!menuActive) {
                closePropList();
            }
            break;
        case 'showPropList':
            propInfoContainer.innerHTML = event.data.propList;

            const propListItems = document.querySelectorAll('.propListItem');
            propListItems.forEach(item => {
                item.addEventListener('click', () => {
                    const propName = item.getAttribute('data-prop');
                    postMessageToClient('spawnProp', { propName });
                    closePropList();
                    closeMenu();
                });
            });
            propListContainer.classList.remove('hidden');
            container.addEventListener('mouseleave', closePropList);
            break;
        }
    }); 

    function closeMenu() {
        menuActive = false;
        postMessageToClient('closeMenu');
        propListContainer.classList.add('hidden');
        container.removeEventListener('mouseleave', closePropList);
    }

    function closePropList() {
        propInfoContainer.innerHTML = '';
        propListContainer.classList.add('hidden');
        container.removeEventListener('mouseleave', closePropList);
    }

    function postMessageToClient(type, data) {
        fetch(`https://${GetParentResourceName()}/fromNui`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ event: "fromNui", type, ...data }),
        });
    }

});



// const body = document.querySelector('body');
// const container = document.getElementById('container');

// body.style.display = 'block'
// container.classList.toggle('hidden', false)