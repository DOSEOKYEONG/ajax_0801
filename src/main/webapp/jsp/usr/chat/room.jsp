<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/head.jspf" %>

<script>
    let Messages__lastId = 0;

    function Messages__load() {
        fetch(`/usr/chat/getMessages/${room.id}/?fromId=\${Messages__lastId}`)
            .then(data => data.json())
            .then(responseData => {
                const messages = responseData.data;
                for (const index in messages) {
                    const message = messages[index];

                    const html = `
                    <li class="flex">
                        <span>메세지 \${message.id} :</span>
                        &nbsp;
                        <span>\${message.body}</a>
                        <a onclick="if ( !confirm('정말로 삭제하시겠습니까?') ) return false;" class="hover:underline hover:text-[red] mr-2" href="/usr/chat/deleteMessage/\${message.id}?_method=DELETE">삭제</a>
                    </li>
                    `;

                    $('.messages').append(html);
                }

                if (messages.length > 0) {
                    Messages__lastId = messages[messages.length - 1].id;
                }

                // Articles__loadMore(); // 즉시 실행
                setTimeout(Messages__load, 3000); // Articles__loadMore(); 를 3초 뒤에 수행
            });
    }
</script>

<script>
    function ChatRoomSave__submitForm(form) {
        form.title.value = form.title.value.trim();

        if (form.title.value.length == 0) {
            alert('제목을 입력해주세요.');
            form.title.focus();
            return;
        }

        form.body.value = form.body.value.trim();

        if (form.body.value.length == 0) {
            alert('내용을 입력해주세요.');
            form.body.focus();
            return;
        }

        form.submit();
    }
</script>

<section>
    <div class="container px-3 mx-auto">
        <h1 class="font-bold text-lg">채팅방</h1>

        <div>
            ${room.title}
        </div>

        <div>
            ${room.body}
        </div>

        <script>
            function ChatMessageSave__submitForm(form) {
                form.body.value = form.body.value.trim();

                if (form.body.value.length == 0) {
                    form.body.focus();

                    return false;
                }

                form.submit();
            }
        </script>

        <form onsubmit="ChatMessageSave__submitForm(this); return false;" method="POST"
              action="/usr/chat/writeMessage/${room.id}">
            <input autofocus name="body" type="text" placeholder="메세지를 입력해주세요." class="input input-bordered"/>
            <button type="submit" value="" class="btn btn-outline btn-primary">
                작성
            </button>
        </form>

        <ul class="messages mt-5">
            <%--            /usr/getMessages/room.id json으로 메세지 제공--%>
        </ul>

    </div>
</section>

<script>
    Messages__load();
</script>

<%@ include file="../common/foot.jspf" %>